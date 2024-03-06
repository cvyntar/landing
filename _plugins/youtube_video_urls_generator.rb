require 'open-uri'
require 'set'
require 'uri'

module Jekyll
    class YoutubeVideoURLsGenerator < Jekyll::Generator
        # Initialize a new instance
        #
        # config - The Hash of configuration options.
        #
        def initialize(config = {})
            super(config)

            theme_config = config['anurina']

            debug = theme_config != nil && theme_config.key?('debug') ? theme_config['debug'] : false
            if (![true, false].include? debug)
                raise Exception.new "Bad configuration value for 'debug' property. Expected instance of boolean. Please check your config."
            end
            @debug = debug

            if (theme_config != nil && theme_config.key?('youtube_channel_id'))
                youtube_channel_id = theme_config['youtube_channel_id']
                if (!youtube_channel_id.instance_of?(String))
                    raise Exception.new "Bad configuration value for 'youtube_channel_id' property. Expected instance of boolean. Please check your config."
                end
                @youtube_channel_id = youtube_channel_id
                self._log_debug("Initialized with YouTube channel ID: #{youtube_channel_id}")
            else
                @youtube_channel_id = nil
                self._log_debug("Warning! Configuration does not provide 'anurina.youtube_channel_id'. A variable 'youtube_video_urls' will not generated.")
            end
            
            if (theme_config != nil && theme_config.key?('cache_ttl_minutes'))
                cache_ttl_minutes = theme_config['cache_ttl_minutes']
                if cache_ttl_minutes != nil
                    @cache_ttl_minutes = cache_ttl_minutes
                    self._log_debug("Cache TTL: #{cache_ttl_minutes}")
                else
                    @cache_ttl_minutes = nil
                    self._log_debug("Warning! Configuration does not provide 'anurina.cache_ttl_minutes. A variable 'cache_ttl_minutes' will not generated.")
                end
            end
        end

        def generate(site)
            if (@youtube_channel_id != nil)
                youtube_video_urls = self._load_video_urls()
                self._log_debug("Loaded #{youtube_video_urls.length()} video URLs.")

                documents = Set.new()
                documents.merge(site.pages)
                documents.merge(site.documents)

                # Inject YouTube video ULRs in all non-post documents
                for document in documents do
                    if (document.data['layout'] != 'post')
                        document.data['youtube_video_urls'] = youtube_video_urls
                        self._log_debug "Inject YouTube video ULRs inside document #{document.path}"
                    end
                end
            end
            return nil
        end

        def _load_video_urls()
            time_now = Time.now
            file_modification_time =  File.mtime(".anurina-cache/cache_links.txt")
            difference = time_now - file_modification_time

            self._log_debug "Trying to load video URLs from cache..."
            urls = self._load_video_urls_cache()
            if urls != nil && (difference < @cache_ttl_minutes)
                self._log_debug "Video URLs were loaded from cache."
            else
                begin
                    urls = self._load_video_urls_remote()
                rescue Exception => e
                    puts "Error: Connection break, load video URLs from old cache..."
                    self._load_video_urls_cache()
                else
                    self._check_cache_time_to_live()
                    self._log_debug "Saving video URLs to cache..."
                    self._save_video_urls_cache(urls)
                end
            end
            return urls
        end

        def _load_video_urls_cache()
            if File.file?(".anurina-cache/cache_links.txt")
                File.open(".anurina-cache/cache_links.txt", "r") do |file|
                    return file.readlines.map(&:chomp)
                end
            else
                return nil
            end
        end

        def _check_cache_time_to_live()
            if File.exist?(".anurina-cache/cache_links.txt") 
                time_now = Time.now
                file_modification_time =  File.mtime(".anurina-cache/cache_links.txt")
                difference = time_now - file_modification_time
                if (difference > @cache_ttl_minutes)
                    self._log_debug "Check how long cache exists"
                    FileUtils.rm_rf(".anurina-cache/cache_links.txt")
                    self._log_debug "Cache delete"
                    return nil
                end
            else
                return nil
            end
        end

        def _load_video_urls_remote()
            youtube_channel_id = @youtube_channel_id
            if (youtube_channel_id == nil)
                raise Exception.new "Invalid operation. _load_video_urls_remote should not be called while 'youtube_channel_id' is not set."
            end

            escaped_youtube_channel_id = URI.encode_www_form_component(youtube_channel_id)
            channel_url = "https://www.youtube.com/#{escaped_youtube_channel_id}"

            self._log_debug("Getting HTML content of #{channel_url}")
            html_content = URI.open(channel_url).read

            self._log_debug("Parsing HTML content for videoIds")
            video_urls = html_content.scan(/"videoId":"([\w-]+)"/).map do |match|
              video_id = match[0]
              "https://www.youtube.com/embed/#{video_id}"
            end

            unique_video_urls = Set.new(video_urls)
            return unique_video_urls.to_a
        end

        def _log_debug(message)
            if(@debug)
                puts "[anurina] YoutubeVideoURLsGenerator #{message}"
            end
            return nil
        end

        def _save_video_urls_cache(video_urls)
            cache_folder = ".anurina-cache"
            cache_file = "cache_links.txt"
        
            self._log_debug "Cheak if folder exist"
            if Dir.exist?(cache_folder)
                File.open(File.join(cache_folder, cache_file), "w") do |file|
                    video_urls.each do |url|
                        file.puts(url)
                    end
                end
            else
                Dir.mkdir(cache_folder)
                self._log_debug "Create folder"
                File.open(File.join(cache_folder, cache_file), "w") do |file|
                    video_urls.each do |url|
                        file.puts(url)
                    end
                end
            end
        end
    end
end        