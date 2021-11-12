require 'objspace'

namespace :profiles do
  desc '実行速度とメモリ使用量を計測する'
  task instrumentation: :environment do


    # /model配下にモジュールを作成している
    # メモリの計測
    Development::UsedMemory.instance.write('start batch')
    Development::UsedMemory.instance.write('end batch')
    Development::UsedMemory.instance.puts_all


    # 実行速度の計測
    Benchmark.bm 10 do |r|
      r.report 'profile' do
        # 速度の対象を設定
        # 今回のn + 1問題を再現
        @user = User.find(1)
        @articles = @user.articles

        @articles.each do |article| 
          puts article.title

          article.tags.each do |tag|
            puts tag.name
          end
        end

      end
    end

  end
end

## 実行時間を測定
# 10のパラメーターは出力結果1行目のラベルごとの文字幅を指定しています。
# r.reportの引数'RanksUpdater'は測定結果に表示するラベルを指定している
# 実行時間を測定したいコードをr.report 'profile'で囲むことで測定対象が設定される
# 今回は測定対象がひとつのみですがr.reportは複数設定することができ、ラベルをつけておくとどの処理の実行時間であるかがわかりやすくなります。

# 最初の2行がBenchmarkの出力結果で、単位は秒です。
# - userとsystemはCPUを使用した時間
#  - userはこのバッチ処理本体が使用したCPUの時間/systemはこのバッチ処理を実行している間にOSが使用したCPU時間
# - totalはuserとsystemの合計
# - 最後のrealが実経過時間。バッチ処理の実行時間はrealの項目で確認することができる