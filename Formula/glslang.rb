class Glslang < Formula
  desc "OpenGL and OpenGL ES shader front end and validator"
  homepage "https://github.com/KhronosGroup/glslang"
  url "https://github.com/KhronosGroup/glslang.git", :commit => "2898223375d57fb3974f24e1e944bb624f67cb73"
  version "7.11.3113"
  head "https://github.com/KhronosGroup/glslang.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "rafaga/r2k/spirv-headers" => :build
  depends_on "rafaga/r2k/spirv-tools"
  conflicts_with "homebrew/core/glslang"

  def install
    # Disabling Tests for now
    args = std_cmake_args + [
      "-DBUILD_SHARED_LIBS=OFF",
      "-DCMAKE_CXX_FLAGS=-I#{HOMEBREW_PREFIX}/include",
      "-DCMAKE_STATIC_LINKER_FLAGS=#{Formula["rafaga/r2k/spirv-tools"].opt_lib}/libSPIRV-Tools.a",
      "-DCMAKE_SHARED_LINKER_FLAGS=#{Formula["rafaga/r2k/spirv-tools"].opt_lib}/libSPIRV-Tools-shared.dylib",
      "-DCMAKE_EXE_LINKER_FLAGS=-L#{HOMEBREW_PREFIX}/lib",
      "-DENABLE_GLSLANG_BINARIES=OFF",
    ]

    pc_file_name = "#{buildpath}/glslang/glslang.pc.cmake.in"

    inreplace Dir["#{buildpath}/glslang/CMakeLists.txt"].each do |s|
      s.gsub! "if(ENABLE_GLSLANG_INSTALL)", \
              "if(ENABLE_GLSLANG_INSTALL)\n" \
              "configure_file(" \
              "${CMAKE_CURRENT_SOURCE_DIR}/glslang.pc.cmake.in " \
              "${CMAKE_CURRENT_BINARY_DIR}/pkgconfig/glslang.pc " \
              "@ONLY)"
      s.gsub! "endif(ENABLE_GLSLANG_INSTALL)", \
              "install(" \
              "FILES ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig/glslang.pc " \
              "DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig" \
              ")\n" \
              "endif(ENABLE_GLSLANG_INSTALL)"
    end

    inreplace Dir["#{buildpath}/CMakeLists.txt"].each do |s|
      s.gsub! "add_subdirectory(External)", "# add_subdirectory(External)"
      s.gsub! "if(ENABLE_OPT)", \
              "set(ENABLE_OPT ON)\n" \
              "if(ENABLE_OPT)"
    end

    inreplace Dir["#{buildpath}/SPIRV/CMakeLists.txt"],
      "target_include_directories(SPIRV PUBLIC ../External)",
      "target_include_directories(SPIRV PUBLIC #{HOMEBREW_PREFIX}/include)"

    mkdir "build" do
      File.write(pc_file_name, pc_file)
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
    end
  end

  # Creating a .pc file to make the library available to other dependencies
  def pc_file; <<~EOS
    prefix=@CMAKE_INSTALL_PREFIX@
    exec_prefix=@CMAKE_INSTALL_PREFIX@
    libdir=${exec_prefix}/@CMAKE_INSTALL_LIBDIR@
    includedir=${prefix}/@CMAKE_INSTALL_INCLUDEDIR@
    \nName: @PROJECT_NAME@
    Description: OpenGL and OpenGL ES shader front end and validator
    Requires:
    Version: 7.11.3113
    Libs: -L${libdir} -lglslang
    Cflags: -I${includedir}
  EOS
  end

  test do
    system "false"
  end
end
