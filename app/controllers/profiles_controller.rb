class ProfilesController < ApplicationController
  def index
    @user = User.find(1)
    # ページが存在するものの、特定のアクセス者にページを表示する権限が付与されず、アクセスが拒否されたことを示す
    raise Forbidden unless user_safe?

    @skill_categories = user_reccomend_skill_categories
    @articles = @user.articles.preload(:tags)
  end

  private

  # 紐づくcaution_freezesが存在しないuser_cautionsレコードは不要になるので、INNER JOIN句を使用
  # ユーザーに紐づく全てのユーザー凍結情報の終了時間と現在時間を比較し、現在凍結期間外である事の確認
  def user_safe?
    @user.user_cautions.joins(:caution_freeze).
    where("caution_freezes.end_time > ?", Time.zone.now).blank?
  end


  def user_reccomend_skill_categories
    SkillCategory.eager_load(:skills).
      where(reccomend: true).
      where(skills: { user_id: @user.id })

  end
end

# filterメソッド
# 各要素に対してブロックを評価した値が真であった要素を全て含む配列を返します。真になる要素がひとつもなかった場合は空の配列をす

# uniqメソッド
# 配列の要素の中で重複している要素を削除して、削除後の配列として返すメソッド
# 配列.uniq  / 配列.uniq{ | ブロック引数 |  ブロック }
# rais5以降ではdistinctが推奨されているため変更

