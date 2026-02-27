import { notFound } from 'next/navigation'
import { MDXRemote } from 'next-mdx-remote/rsc'
import { Header } from '@/components/Header'
import { getPostBySlug, getAllPosts } from '@/lib/posts'

interface BlogPostPageProps {
  params: {
    slug: string
  }
}

export default function BlogPostPage({ params }: BlogPostPageProps) {
  const post = getPostBySlug(params.slug)

  if (!post) {
    notFound()
  }

  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="container py-6 md:py-12">
        <article className="prose prose-stone dark:prose-invert mx-auto">
          <h1 className="mb-2">{post.title}</h1>
          <p className="text-muted-foreground mb-8">{post.date}</p>
          <MDXRemote source={post.content} />
        </article>
      </main>
    </div>
  )
}

export const dynamicParams = false
export const dynamic = 'force-static'
export const runtime = 'nodejs'

export async function generateStaticParams() {
  const posts = getAllPosts()
  return posts.map((post) => ({
    slug: post.slug,
  }))
} 
