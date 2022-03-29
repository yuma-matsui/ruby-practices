# frozen_string_literal: true

module Effects
  # 隠しファイルを配列から削除
  def self.excludes_secret!
    ->(files) { files.reject! { |f| f.start_with?('.') } }
  end

  def self.reverse!
    ->(files) { files.reverse! }
  end
end
