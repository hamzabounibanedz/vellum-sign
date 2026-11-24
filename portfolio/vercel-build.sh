#!/usr/bin/env bash
set -euo pipefail
cd ../..
export NEXT_PRIVATE_DATABASE_URL="${DATABASE_URL:?DATABASE_URL missing}"
export NEXT_PRIVATE_DIRECT_DATABASE_URL="$DATABASE_URL"
npm run prisma:migrate-deploy --workspace=@documenso/prisma
node --input-type=module <<'NODE'
import { readFileSync, writeFileSync } from 'node:fs';
const path = 'apps/remix/app/utils/meta.ts';
const input = readFileSync(path, 'utf8');
writeFileSync(path, input.replace("${i18n._(title)} - Documenso` : 'Documenso'", "${i18n._(title)} - Vellum Sign` : 'Vellum Sign'").replace(/Join Documenso,.*?community\./, 'Prepare documents, collect signatures, and track agreement status in Vellum Sign.').replace('Documenso - The Open Source DocuSign Alternative', 'Vellum Sign — Document signing'));
NODE
npx --no-install turbo run build --filter=@documenso/remix --env-mode=loose
cd apps/remix/build/server
mkdir -p hono/packages/lib/translations
cp -R ../../../../packages/lib/translations/. hono/packages/lib/translations/
mv index.js manifest.js
cat > index.js <<'ENTRY'
import handle from 'hono-react-router-adapter/node';
import { getLoadContext } from './hono/server/load-context.js';
import server from './hono/server/router.js';
import * as manifest from './manifest.js';

export * from './manifest.js';
const app = handle(manifest, server, { getLoadContext });
export default (request) => app.fetch(request);
ENTRY
for catalog in hono/packages/lib/translations/*/web.mjs; do
  test -f "$catalog"
  printf '\nimport "./%s";\n' "$catalog" >> index.js
done
node --input-type=module -e "await import('./index.js'); process.exit(0)"
