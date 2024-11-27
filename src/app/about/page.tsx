import { Header } from '@/components/Header'

export default function AboutPage() {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="container py-6 md:py-12">
        <div className="max-w-[768px] mx-auto">
          <h1 className="text-3xl font-extrabold leading-tight tracking-tighter md:text-4xl mb-6">
            关于我和这个博客
          </h1>
          
          <div className="prose prose-stone dark:prose-invert max-w-none">
            <section className="mb-8">
              <h2 className="text-2xl font-bold mb-4">为什么选择"大道至简"</h2>
              <p className="text-lg text-muted-foreground mb-4">
                我一直被道家"大道至简，至简至美"的理念所打动。在这个信息爆炸的时代，
                我希望通过这个博客，记录我寻找简单、平静生活的旅程。
              </p>
              <p className="text-lg text-muted-foreground">
                对我来说，简约不是刻意的减法，而是找到真正重要的事物。
                通过写作，我想分享我在这条道路上的思考和感悟。
              </p>
            </section>

            <section className="mb-8">
              <h2 className="text-2xl font-bold mb-4">我会写些什么</h2>
              <ul className="space-y-4 text-muted-foreground">
                <li>
                  <strong className="text-foreground">生活感悟：</strong>
                  记录日常生活中的思考和领悟
                </li>
                <li>
                  <strong className="text-foreground">阅读心得：</strong>
                  分享读书笔记和对古今智慧的理解
                </li>
                <li>
                  <strong className="text-foreground">生活方式：</strong>
                  记录我如何实践简约生活的点点滴滴
                </li>
                <li>
                  <strong className="text-foreground">个人成长：</strong>
                  分享我在工作和生活中的学习与成长
                </li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-bold mb-4">与我联系</h2>
              <p className="text-lg text-muted-foreground">
                如果你对简约生活也有兴趣，或者想交流任何想法，欢迎与我联系。
                期待能与志同道合的朋友一起探讨、成长。
              </p>
            </section>
          </div>
        </div>
      </main>
    </div>
  )
} 