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

  def all_info
    str = "#{ftype}#{permission}#{nlink} #{owner_name}  #{group_name} #{size} #{time_stamp} #{file_name}"
    str += " -> #{symlink}" if symlink?
    str
  end

  def ftype
    FILE_TYPE[@file.ftype]
  end

  def permission
    FilePermission.new(@file.mode).to_string
  end

  def file_name
    @path.split('/').last
  end

  def blocks
    @file.blocks
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
    time = @file.mtime
    month = time.month.to_s.rjust(2)
    day = time.day.to_s.rjust(2)
    hour = time.hour.to_s.rjust(2, '0')
    min = time.min.to_s.rjust(2, '0')
    "#{month} #{day} #{hour}:#{min}"
  end

  def symlink
    File.readlink(@path)
  end

  def symlink?
    @file.symlink?
  end
end
