import type { SVGAttributes } from 'react';

export type LogoProps = SVGAttributes<SVGSVGElement>;

export const BrandingLogo = ({ ...props }: LogoProps) => {
  return (
    <svg viewBox="0 0 136 24" role="img" aria-label="Vellum Sign" {...props}>
      <rect width="24" height="24" rx="5" fill="#663b46" />
      <path d="M4 5h13l3 3v11H4zm3 3v8h10V9l-2-1z" fill="white" fillRule="evenodd" />
      <text x="30" y="18" fill="currentColor" fontFamily="inherit" fontWeight="650" fontSize="19">Vellum Sign</text>
    </svg>
  );
};
