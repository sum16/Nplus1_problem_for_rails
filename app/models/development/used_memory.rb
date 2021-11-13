require 'objspace'
module Development
  class UsedMemory
    # Singletonモジュールを使用, 組み込みモジュールはincludeで読み込み

    # initializeで初期化した@reports変数にはwriteメソッド内で実行しているObjectSpace.memsize_of_allの結果が追記されている
    def initialize
      @reports = []
    end

    # メモリ消費量を測定するメソッド
    def write(label)
      @reports << "使用メモリ: #{label} #{ObjectSpace.memsize_of_all * 0.001 * 0.001} MB"
    end

    def puts_all(array)
      array.each { |report| puts report }
    end
  end
end