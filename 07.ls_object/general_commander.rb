# frozen_string_literal: true

class GeneralCommander
  def initialize(args)
    file_paths = collect_file_paths(args[:path], args[:is_dotmatch])

    file_paths.reverse! if args[:is_reversed]
    is_file_path = args[:path] ? FileTest.file?(args[:path]) : false

    @commander = args[:is_detailed] ? LongCommander.new(file_paths:, is_file_path:) : ShortCommander.new(file_paths:, is_file_path:)
  end

  def show
    @commander.show
  end

  private

  def collect_file_paths(path, is_dotmatch)
    dotmatch_pattern = is_dotmatch ? File::FNM_DOTMATCH : 0

    if path.nil?
      Dir.glob('*', dotmatch_pattern)
    elsif FileTest.directory?(path)
      Dir.glob(File.join(path, '*'), dotmatch_pattern)
    elsif FileTest.file?(path)
      [path]
    else
      puts "ls: #{path}: No such file or directory"
      exit
    end
  end
end
