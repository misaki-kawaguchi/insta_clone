class SearchPostsForm
  # モデル名の調査、変換、翻訳、バリデーションが使えるようになる
  include ActiveModel::Model
  # 既存のアトリビュートの値を適切な型に変換したり、任意のアトリビュートを定義出来る
  include ActiveModel::Attributes

  # paramsで渡されるパラメータ名を並べる
  attribute :body, :string

  def search
    # Postモデルから重複するレコードを削除して取得
    scope = Post.distinct
    # 本文が存在する場合、検索したい文字列を本文から完全一致検索する
    scope = scope.body_contain(body) if body.present?
    scope
  end
end