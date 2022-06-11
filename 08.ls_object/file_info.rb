# frozen_string_literal: true

require_relative 'file_permission'
require 'etc'

class FileInfo
  # ファイルタイプ判定用
  FILE_TYPE = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }.freeze

  def initialize(path)
    @path = path
    @file = File.lstat(@path)
  end

  def info
    {
      ftype: ftype,
      permission: permission,
      nlink: nlink,
      owner_name: owner_name,
      group_name: group_name,
      size: size,
      time_stamp: time_stamp,
      file_name: file_name,
      symlink: symlink
    }
  end

  def blocks
    @file.blocks
  end

  private

  def ftype
    FILE_TYPE[@file.ftype]
  end

  def permission
    FilePermission.new(@file.mode).to_s
  end

  def file_name
    @path.split('/').last
  end

  def nlink
    @file.nlink.to_s.rjust(3)
  end

  def owner_name
    Etc.getpwuid(@file.uid).name
  end

  def group_name
    Etc.getgrgid(@file.gid).name
  end

  def size
    @file.size.to_s.rjust(4)
  end

  def time_stamp
    @file.mtime.strftime('%_m %_d %H:%M')
  end

  def symlink
    symlink? ? File.readlink(@path) : nil
  end

  def symlink?
    @file.symlink?
  end
end
