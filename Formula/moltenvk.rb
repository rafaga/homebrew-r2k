class Moltenvk < Formula
  desc "Implementation of the Vulkan 1.0 API, that runs on Apple's Metal API"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  url "https://github.com/KhronosGroup/MoltenVK.git", :tag => "v1.0.32"
  version "1.0.32"
  head "https://github.com/KhronosGroup/MoltenVK.git"

  depends_on "cereal" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python" => :build
  depends_on "rafaga/r2k/glslang"
  depends_on "rafaga/r2k/spirv-cross"
  depends_on "rafaga/r2k/spirv-tools"
  depends_on "rafaga/r2k/vulkan-headers"
  depends_on "rafaga/r2k/vulkan-portability"

  # resource "VulkanSamples" do
  #   url "https://github.com/LunarG/VulkanSamples.git", :commit => "5810b01149ef4f76fd92d7e085d980017379a93b"
  # end
  def install
    inreplace Dir["#{buildpath}/MoltenVKShaderConverter/MoltenVKSPIRVToMSLConverter/SPIRVToMSLConverter.h"],
    '#include "../SPIRV-Cross/spirv.hpp"',
     "#include <spirv_cross/spirv.hpp>"

    inreplace Dir["#{buildpath}/MoltenVKShaderConverter/MoltenVKGLSLToSPIRVConverter/GLSLToSPIRVConverter.cpp"].each do |s|
      s.gsub! '#include "../glslang/SPIRV/GlslangToSpv.h"', "#include <SPIRV/GlslangToSpv.h>"
      s.gsub! '#include "../glslang/SPIRV/disassemble.h"', "#include <SPIRV/disassemble.h>"
      s.gsub! '#include "../glslang/SPIRV/doc.h"', "#include <SPIRV/doc.h>"
    end

    inreplace Dir["#{buildpath}/MoltenVK/MoltenVK/API/mvk_vulkan.h"],
    "#include <vulkan-portability/vk_extx_portability_subset.h>",
    "#include <vulkan/vk_extx_portability_subset.h>"

    inreplace "#{buildpath}/MoltenVKShaderConverter/MoltenVKShaderConverter.xcodeproj/project.pbxproj" do |s|
      # libraries
      s.gsub! '"\"$(SRCROOT)/../External/build/macOS\""', '"\"' + "#{HOMEBREW_PREFIX}/lib/" +'\""'
      # includes
      s.gsub! "PRODUCT_NAME = MoltenVKGLSLToSPIRVConverter;", \
          "PRODUCT_NAME = MoltenVKGLSLToSPIRVConverter;" \
          "HEADER_SEARCH_PATHS = (" \
          "\"$(inherited)\"," \
          "\"#{Formula["rafaga/r2k/spirv-cross"].opt_include}/**\"," \
          "\"#{Formula["rafaga/r2k/spirv-tools"].opt_include}/**\"," \
          "\"#{HOMEBREW_PREFIX}/include/\"," \
          "\"#{Formula["rafaga/r2k/spirv-headers"].opt_include}/**\"," \
          "\"#{Formula["rafaga/r2k/glslang"].opt_include}/**\"," \
          ");" \
          "LIBRARY_SEARCH_PATHS = #{HOMEBREW_PREFIX}/lib/;"
      s.gsub! "MACOSX_DEPLOYMENT_TARGET = 10.11;", "MACOSX_DEPLOYMENT_TARGET = #{MacOS.version};"
      s.gsub! '"\"$(SRCROOT)/SPIRV-Cross\"",',
      '"\"' + "#{Formula["rafaga/r2k/spirv-cross"].opt_include}/**" +'\"",'
      s.gsub! '"\"$(SRCROOT)/glslang/External/spirv-tools/\"",',
      '"\"' + "#{Formula["rafaga/r2k/spirv-tools"].opt_include}/**" +'\"",'
      s.gsub! '"\"$(SRCROOT)/glslang/External/spirv-tools/include\"",',
      '"\"' + "#{HOMEBREW_PREFIX}/include/" +'\"",'
      s.gsub! '"\"$(SRCROOT)/glslang/External/spirv-tools/external/spirv-headers/include\"",',
       '"\"' + "#{Formula["rafaga/r2k/spirv-headers"].opt_include}/**" +'\"",'
      s.gsub! '"\"$(SRCROOT)/glslang/build/External/spirv-tools\"",',
      '"\"' + "#{Formula["rafaga/r2k/glslang"].opt_include}/**" +'\"",'
      s.gsub! "name = libSPIRVTools.a; path = ../External/build/macOS/libSPIRVTools.a;",
              "name = libSPIRV-Tools.a; path = #{Formula["rafaga/r2k/spirv-tools"].opt_lib}/libSPIRV-Tools.a;"
      s.gsub! "name = libSPIRVCross.a; path = ../External/build/macOS/libSPIRVCross.a;",
      "name = libspirv-cross-core.a; path = #{Formula["rafaga/r2k/spirv-cross"].opt_lib}/libspirv-cross-core.a;"
      s.gsub! "path = ../External/build/macOS/libglslang.a;",
       "path = #{Formula["rafaga/r2k/glslang"].opt_lib}/libglslang.a;"
      s.gsub! "OTHER_LDFLAGS = \"-ObjC\";", \
          "OTHER_LDFLAGS = \"-ObjC\";" \
          "HEADER_SEARCH_PATHS = (" \
          "\"$(inherited)\"," \
          "\"#{Formula["rafaga/r2k/spirv-cross"].opt_include}/**\"," \
          "\"#{Formula["rafaga/r2k/spirv-tools"].opt_include}/**\"," \
          "\"#{HOMEBREW_PREFIX}/include/\"," \
          "\"#{Formula["rafaga/r2k/spirv-headers"].opt_include}/**\"," \
          "\"#{Formula["rafaga/r2k/glslang"].opt_include}/**\"," \
        ");" \
        "LIBRARY_SEARCH_PATHS = #{HOMEBREW_PREFIX}/lib/;"
    end

    inreplace Dir["#{buildpath}/Scripts/package_ext_libs.sh"],
    'export MVK_EXT_LIB_DST_DIR="External"',
     "export MVK_EXT_LIB_DST_DIR=\"#{HOMEBREW_PREFIX}/lib/\""

    inreplace "#{buildpath}/MoltenVK/MoltenVK.xcodeproj/project.pbxproj" do |s|
      s.gsub! '"\"$(SRCROOT)/../External/cereal/include\"",', "\"#{Formula["cereal"].opt_include}\","
      s.gsub! "MACOSX_DEPLOYMENT_TARGET = 10.11;", "MACOSX_DEPLOYMENT_TARGET = #{MacOS.version};"
    end

    xcodebuild "-project",
      "MoltenVKPackaging.xcodeproj",
      "-scheme",
      "MoltenVK Package (macOS only)",
      "-derivedDataPath",
      "./DerivedData",
      "build",
      "SYMROOT=build",
      "OBJROOT=build"
  end

  test do
    system "false"
  end
end
