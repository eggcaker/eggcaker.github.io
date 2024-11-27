import Link from 'next/link'
import Image from 'next/image'

interface BlogCardProps {
  title: string
  excerpt: string
  date: string
  slug: string
  coverImage?: string
}

export function BlogCard({ title, excerpt, date, slug, coverImage }: BlogCardProps) {
  return (
    <div className="group relative rounded-lg border p-6 hover:border-foreground/50">
      <div className="flex flex-col justify-between space-y-4">
        {coverImage && (
          <div className="relative aspect-video overflow-hidden rounded-lg">
            <Image
              src={coverImage}
              alt={title}
              fill
              className="object-cover transition-transform group-hover:scale-105"
            />
          </div>
        )}
        <div className="space-y-2">
          <h3 className="text-xl font-bold leading-none tracking-tight">
            <Link href={`/blog/${slug}`} className="hover:underline">
              {title}
            </Link>
          </h3>
          <p className="text-sm text-muted-foreground">{date}</p>
          <p className="text-muted-foreground line-clamp-3">{excerpt}</p>
        </div>
      </div>
    </div>
  )
} 