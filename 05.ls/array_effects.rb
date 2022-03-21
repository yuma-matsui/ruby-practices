# frozen_string_literal: true

module ArrayEffects
  private

  def excludes_secret
    @files.reject! { |f| f.start_with?('.') }
  end

  def sorts
    @files.sort!
  end

  # 空白を挿入してファイル名を20文字に統一
  def insert_space_into_file_name
    @files.map! { |file| file.ljust(20) }
  end
end
