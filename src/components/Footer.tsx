export function Footer() {
  const currentYear = "2024" //new Date().getFullYear().toString()

  return (
    <footer className="border-t bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex h-14 items-center justify-center text-sm text-muted-foreground">
        <p>
          © {currentYear} 大道至简. Built with{' '}
          <a
            href="https://nextjs.org"
            target="_blank"
            rel="noopener noreferrer"
            className="font-medium underline underline-offset-4 hover:text-foreground"
          >
            Next.js
          </a>
        </p>
      </div>
    </footer>
  )
} 