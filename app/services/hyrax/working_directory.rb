# frozen_string_literal: true
module Hyrax
  # @deprecated Use JobIoWrapper instead
  class WorkingDirectory
    class << self
      # @param [#original_name, #id] file the resource in the repo
      # @param [String] id the identifier of the FileSet
      # @return [String] path of the working file
      def copy_repository_resource_to_working_directory(file, id)
        Rails.logger.debug "Loading #{file.original_name} (#{file.id}) from the repository to the working directory"
        copy_stream_to_working_directory(id, file.original_name, StringIO.new(file.content))
      end

      private

      # @param [String] id the identifier
      # @param [String] name the file name
      # @param [#read] stream the stream to copy to the working directory
      # @return [String] path of the working file
      def copy_stream_to_working_directory(id, name, stream)
        working_path = full_filename(id, name)
        Rails.logger.debug "Writing #{name} to the working directory at #{working_path}"
        FileUtils.mkdir_p(File.dirname(working_path))
        IO.copy_stream(stream, working_path)
        working_path
      end

      def full_filename(id, original_name)
        pair = id.scan(/..?/).first(4).push(id)
        File.join(Hyrax.config.working_path, *pair, original_name)
      end
    end
  end
end
