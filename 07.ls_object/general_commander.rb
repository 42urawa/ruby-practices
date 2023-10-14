# frozen_string_literal: true

class GeneralCommander
  def initialize(args)
    dotmatch_pattern = args[:is_dotmatch] ? File::FNM_DOTMATCH : 0

    file_paths = if args[:path].nil?
                   Dir.glob('*', dotmatch_pattern)
                 elsif FileTest.directory?(args[:path])
                   Dir.glob(File.join(args[:path], '*'), dotmatch_pattern)
                 elsif FileTest.file?(args[:path])
                   [args[:path]]
                 else
                   puts "ls: #{args[:path]}: No such file or directory"
                   exit
                 end

    file_paths.reverse! if args[:is_reversed]

    @commander = if args[:is_detailed]
                   LongCommander.new(file_paths)
                 else
                   ShortCommander.new(file_paths)
                 end
  end

  def show
    @commander.show
  end
end
