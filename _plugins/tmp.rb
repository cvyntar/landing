# module Jekyll
#     class LiquidRenderer
#         File.class_eval do
#             alias_method :super_parse1, :parse
#             def parse(content)
#                 puts "Local::Jekyll::LiquidRenderer::parse Processing " + @filename
#                 super_parse1(content)
#             end
#         end
#     end
# end