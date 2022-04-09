# frozen_string_literal: true

class FilePermission
  # パーミッション判定用
  PERMISSION = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(mode_num)
    @mode_num = mode_num.to_s(8).rjust(6, '0')
    @supecial_auth = @mode_num[2]
  end

  def to_string
    "#{user_permission}#{group_permission}#{other_permission}"
  end

  private

  def user_permission
    permission = PERMISSION[@mode_num[3]]
    set_uid? ? attach_special_auth(permission, 'S') : permission
  end

  def group_permission
    permission = PERMISSION[@mode_num[4]]
    set_gid? ? attach_special_auth(permission, 'S') : permission
  end

  def other_permission
    permission = PERMISSION[@mode_num[5]]
    sticky? ? attach_special_auth(permission, 'T') : permission
  end

  # ファイルがsticky or SUID or GUIDの場合の処理
  def attach_special_auth(permission, set_char)
    set_char = set_char.downcase if excutable?(permission)
    permission
      .chars
      .map
      .each_with_index { |char, idx| idx == 2 ? set_char : char }
      .join
  end

  def sticky?
    @supecial_auth == '1'
  end

  def set_gid?
    @supecial_auth == '2'
  end

  def set_uid?
    @supecial_auth == '4'
  end

  def excutable?(permission)
    permission[-1] == 'x'
  end
end
