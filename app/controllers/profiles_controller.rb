class ProfilesController < ApplicationController
  def index
    @user = User.find(1)
    # ページが存在するものの、特定のアクセス者にページを表示する権限が付与されず、アクセスが拒否されたことを示す
    raise Forbidden unless user_safe?

    @skill_categories = user_reccomend_skill_categories
    @articles = @user.articles
  end

  private

  def user_safe?
    @user.user_cautions.all? do |user_caution|
      # 最終時間が現在時刻より前であることを評価
      Time.zone.now > user_caution.caution_freeze.end_time
    end
  end
  # all? → 全ての要素が真であればtrueを返す ブロックの中を評価


  def user_reccomend_skill_categories
    @user.skills.map(&:skill_category).
      filter { |skill_category| skill_category.reccomend }.uniq
  end
end
