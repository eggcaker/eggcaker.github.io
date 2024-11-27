import { Header } from '@/components/Header'
import { BlogCard } from '@/components/BlogCard'
import { getAllPosts } from '@/lib/posts'

export default function BlogPage() {
  const posts = getAllPosts()

  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="container py-6 md:py-12">
        <div className="flex max-w-[980px] flex-col items-start gap-2">
          <h1 className="text-3xl font-extrabold leading-tight tracking-tighter md:text-4xl">
            博客文章
          </h1>
          <p className="max-w-[700px] text-lg text-muted-foreground">
            探索简约之道，分享生活智慧的文章集
          </p>
        </div>
        <div className="mt-8 grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {posts.map((post) => (
            <BlogCard
              key={post.slug}
              title={post.title}
              excerpt={post.excerpt}
              date={post.date}
              slug={post.slug}
            />
          ))}
        </div>
      </main>
    </div>
  )
} 