import { Header } from '@/components/Header'
import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';

import { getAllPosts } from '@/lib/posts'
import Link from 'next/link';

const posts = getAllPosts()

export default function Home() {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="container py-6 md:py-12">
        <div className="flex max-w-[980px] flex-col items-start gap-2">
          <h1 className="text-3xl font-extrabold leading-tight tracking-tighter md:text-4xl">
            大道至简
          </h1>
          <p className="max-w-[700px] text-lg text-muted-foreground">
            探索简约之道，分享生活智慧
          </p>
        </div>
        <div className="mt-8">
          <div className="space-y-4">
            {posts.map((post) => (
              <article key={post.slug}>
                <Link href={`/blog/${post.slug}`}>
                  <div className="inline-block">
                    <h3 className="text-xl font-semibold inline">{post.title}</h3>
                    <time className="text-sm text-muted-foreground inline ml-2">
                      {post.date}
                    </time>
                  </div>
                </Link>
              </article>
            ))}
          </div>
          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            {/* Blog post cards will be added here */}
          </div>
        </div>
      </main>
    </div>
  )
}
