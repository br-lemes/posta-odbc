function load_image_webmail_png()
  local webmail_png = iup.imagergba
  {
    width = 24,
    height = 24,
    pixels = {
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98, 197, 0, 5, 114, 178, 29, 18, 122, 186, 90, 60, 149, 189, 176, 76, 160, 192, 244, 84, 163, 193, 255, 85, 163, 191, 255, 87, 164, 189, 255, 77, 160, 190, 244, 59, 148, 189, 176, 18, 123, 186, 90, 4, 114, 180, 29, 0, 103, 193, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 0, 2, 75, 111, 0, 73, 255, 255, 0, 16, 120, 176, 62, 53, 146, 189, 181, 126, 189, 186, 251, 173, 220, 155, 255, 202, 241, 120, 255, 215, 247, 110, 255, 204, 241, 123, 255, 182, 229, 150, 255, 181, 229, 143, 255, 171, 218, 157, 255, 123, 187, 192, 251, 53, 146, 189, 181, 15, 120, 181, 62, 70, 255, 255, 0, 2, 75, 115, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 6, 110, 163, 0, 0, 12, 68, 1, 15, 120, 174, 79, 76, 160, 205, 223, 163, 213, 208, 255, 205, 246, 132, 255, 216, 250, 121, 255, 201, 238, 179, 255, 179, 228, 192, 255, 161, 220, 200, 255, 134, 206, 222, 255, 120, 202, 174, 255, 158, 226, 55, 255, 189, 237, 81, 255, 168, 215, 174, 255, 75, 159, 202, 223, 14, 120, 184, 79, 0, 17, 67, 1, 5, 110, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 72, 162, 207, 0, 17, 120, 172, 67, 78, 161, 203, 229, 154, 211, 242, 255, 179, 232, 187, 255, 219, 248, 164, 255, 209, 240, 209, 255, 186, 227, 255, 255, 172, 222, 255, 255, 159, 216, 246, 255, 155, 216, 206, 255, 129, 203, 213, 255, 97, 191, 186, 255, 115, 205, 78, 255, 158, 225, 48, 255, 170, 220, 146, 255, 78, 161, 196, 229, 17, 120, 179, 67, 71, 161, 207, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      24, 141, 200, 0, 16, 112, 160, 37, 57, 147, 193, 200, 150, 208, 238, 255, 151, 216, 251, 255, 197, 233, 253, 255, 213, 242, 211, 255, 207, 242, 176, 255, 180, 227, 236, 255, 163, 219, 246, 255, 161, 220, 195, 255, 177, 233, 82, 255, 165, 228, 69, 255, 118, 202, 149, 255, 74, 179, 188, 255, 104, 198, 75, 255, 146, 219, 37, 255, 151, 208, 174, 255, 56, 146, 197, 200, 16, 112, 165, 37, 24, 141, 205, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      61, 255, 255, 0, 23, 123, 174, 121, 125, 190, 223, 253, 137, 211, 248, 255, 182, 228, 252, 255, 211, 240, 228, 255, 211, 246, 153, 255, 209, 248, 110, 255, 192, 239, 130, 255, 183, 236, 112, 255, 176, 234, 85, 255, 155, 222, 107, 255, 149, 221, 78, 255, 131, 212, 77, 255, 67, 176, 207, 255, 55, 170, 207, 255, 79, 184, 117, 255, 139, 213, 67, 255, 132, 194, 176, 253, 21, 123, 184, 121, 56, 255, 255, 0, 10, 52, 73, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      3, 95, 142, 34, 71, 153, 194, 187, 131, 202, 238, 255, 137, 210, 248, 255, 201, 235, 253, 255, 192, 232, 252, 255, 189, 233, 223, 255, 196, 242, 121, 255, 192, 243, 72, 255, 184, 240, 52, 255, 164, 230, 77, 255, 145, 219, 93, 255, 133, 214, 74, 255, 94, 191, 156, 255, 61, 173, 222, 255, 45, 164, 235, 255, 43, 163, 212, 255, 94, 191, 85, 255, 155, 215, 100, 255, 71, 153, 191, 188, 3, 96, 150, 31, 24, 135, 196, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      6, 103, 152, 74, 90, 169, 209, 239, 113, 198, 242, 255, 148, 213, 247, 255, 187, 229, 251, 255, 178, 226, 255, 255, 175, 227, 231, 255, 187, 240, 107, 255, 184, 241, 52, 255, 176, 237, 34, 255, 145, 220, 98, 255, 135, 216, 82, 255, 139, 220, 38, 255, 96, 193, 154, 255, 60, 172, 225, 255, 49, 165, 227, 255, 36, 159, 227, 255, 39, 161, 191, 255, 137, 211, 57, 255, 97, 173, 168, 240, 3, 102, 172, 68, 27, 174, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      8, 101, 148, 89, 83, 170, 215, 254, 107, 198, 244, 255, 142, 210, 246, 255, 172, 223, 250, 255, 161, 219, 254, 255, 159, 221, 224, 255, 178, 237, 86, 255, 176, 239, 31, 255, 166, 235, 16, 255, 156, 230, 12, 255, 150, 227, 13, 255, 153, 229, 0, 255, 136, 217, 35, 255, 72, 178, 187, 255, 47, 164, 228, 255, 37, 158, 223, 255, 26, 153, 215, 255, 117, 203, 66, 255, 101, 180, 129, 255, 3, 98, 178, 81, 33, 217, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      11, 101, 146, 90, 70, 165, 215, 254, 94, 191, 246, 255, 120, 201, 244, 255, 155, 216, 247, 255, 142, 211, 253, 255, 146, 217, 195, 255, 179, 241, 26, 255, 169, 238, 12, 255, 160, 234, 2, 255, 156, 231, 0, 255, 155, 229, 0, 255, 144, 222, 20, 255, 93, 191, 143, 255, 54, 168, 227, 255, 44, 163, 225, 255, 35, 158, 221, 255, 22, 151, 220, 255, 80, 183, 117, 255, 94, 178, 106, 255, 6, 97, 179, 83, 39, 234, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
      14, 101, 150, 90, 61, 162, 201, 254, 102, 199, 195, 255, 94, 190, 238, 255, 129, 204, 244, 255, 123, 202, 250, 255, 127, 208, 196, 255, 169, 239, 18, 255, 165, 239, 0, 255, 160, 236, 0, 255, 157, 234, 0, 255, 154, 231, 0, 255, 113, 205, 87, 255, 50, 167, 238, 255, 43, 164, 228, 255, 35, 159, 222, 255, 25, 154, 218, 255, 12, 147, 219, 255, 22, 151, 192, 255, 42, 150, 155, 255, 11, 101, 161, 83, 35, 247, 255, 0, 0, 0, 207, 0, 0, 0, 22, 0, 
      17, 103, 151, 89, 50, 155, 200, 253, 140, 223, 94, 255, 88, 189, 211, 255, 92, 188, 239, 255, 100, 191, 244, 255, 100, 196, 211, 255, 131, 208, 109, 255, 139, 196, 160, 255, 138, 195, 178, 255, 136, 194, 175, 255, 137, 193, 175, 255, 126, 187, 196, 255, 113, 179, 225, 255, 112, 178, 221, 255, 110, 177, 220, 255, 108, 176, 219, 255, 106, 175, 219, 255, 103, 173, 221, 255, 103, 170, 218, 255, 122, 176, 214, 209, 137, 186, 221, 187, 122, 175, 213, 162, 92, 146, 186, 42, 
      17, 89, 127, 67, 36, 139, 198, 221, 119, 209, 116, 255, 87, 188, 198, 255, 72, 178, 235, 255, 76, 181, 235, 255, 74, 182, 237, 255, 88, 170, 218, 255, 193, 218, 240, 255, 205, 232, 253, 255, 210, 236, 255, 255, 201, 232, 255, 255, 205, 234, 254, 255, 207, 235, 251, 255, 207, 235, 251, 255, 207, 235, 251, 255, 208, 236, 252, 255, 208, 236, 252, 255, 208, 236, 252, 255, 206, 236, 252, 255, 213, 239, 251, 255, 207, 235, 248, 255, 165, 203, 227, 253, 77, 133, 174, 84, 
      7, 33, 46, 27, 28, 122, 172, 167, 51, 163, 218, 255, 61, 173, 233, 255, 64, 174, 230, 255, 66, 176, 230, 255, 64, 176, 233, 255, 83, 167, 217, 255, 195, 222, 238, 255, 175, 216, 244, 255, 198, 228, 248, 255, 187, 228, 255, 255, 179, 225, 255, 255, 181, 225, 255, 255, 181, 225, 255, 255, 181, 225, 255, 255, 181, 225, 255, 255, 180, 225, 255, 255, 179, 225, 255, 255, 193, 231, 255, 255, 190, 223, 245, 255, 184, 222, 246, 255, 168, 205, 228, 254, 71, 124, 164, 90, 
      0, 0, 0, 5, 22, 100, 139, 100, 36, 142, 195, 238, 51, 167, 226, 255, 55, 170, 227, 255, 57, 170, 227, 255, 54, 171, 229, 255, 78, 164, 214, 255, 197, 223, 240, 255, 188, 229, 253, 255, 166, 209, 238, 255, 200, 229, 247, 255, 195, 232, 255, 255, 188, 229, 255, 255, 189, 229, 255, 255, 189, 229, 255, 255, 189, 229, 255, 255, 188, 229, 255, 255, 201, 234, 255, 255, 190, 222, 242, 255, 166, 211, 241, 255, 202, 236, 255, 255, 166, 204, 228, 254, 71, 123, 163, 90, 
      0, 0, 0, 2, 4, 19, 27, 28, 26, 114, 158, 160, 39, 150, 206, 253, 46, 164, 224, 255, 48, 166, 224, 255, 43, 165, 225, 255, 73, 161, 213, 255, 196, 223, 240, 255, 200, 236, 255, 255, 185, 226, 250, 255, 162, 206, 234, 255, 202, 230, 246, 255, 203, 236, 255, 255, 195, 232, 255, 255, 196, 232, 255, 255, 196, 232, 255, 255, 207, 238, 254, 255, 191, 222, 241, 255, 163, 208, 237, 255, 189, 229, 253, 255, 208, 239, 255, 255, 165, 203, 228, 254, 71, 123, 163, 90, 
      0, 0, 0, 0, 0, 0, 0, 7, 8, 36, 50, 47, 28, 120, 166, 183, 35, 149, 205, 255, 38, 160, 221, 255, 33, 160, 222, 255, 68, 159, 211, 255, 197, 224, 240, 255, 203, 237, 255, 255, 199, 235, 255, 255, 185, 224, 247, 255, 160, 203, 232, 255, 205, 232, 246, 255, 210, 240, 255, 255, 203, 237, 255, 255, 213, 241, 255, 255, 193, 223, 241, 255, 159, 204, 233, 255, 192, 229, 251, 255, 198, 234, 255, 255, 210, 240, 255, 255, 164, 203, 228, 254, 71, 123, 163, 90, 
      0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 9, 9, 42, 58, 55, 26, 115, 159, 172, 31, 140, 196, 247, 23, 152, 215, 255, 63, 156, 210, 255, 198, 225, 240, 255, 208, 239, 255, 255, 206, 238, 255, 255, 213, 238, 251, 255, 150, 196, 227, 255, 155, 199, 227, 255, 206, 231, 244, 255, 222, 242, 250, 255, 193, 222, 239, 255, 147, 194, 225, 255, 164, 205, 232, 255, 216, 242, 254, 255, 204, 236, 255, 255, 214, 242, 255, 255, 164, 204, 228, 254, 71, 123, 163, 90, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 9, 7, 28, 39, 42, 22, 94, 129, 127, 20, 122, 172, 205, 65, 146, 194, 240, 197, 226, 241, 255, 215, 244, 255, 255, 212, 237, 250, 255, 165, 205, 230, 255, 172, 211, 235, 255, 183, 220, 241, 255, 140, 188, 220, 255, 136, 184, 217, 255, 146, 193, 223, 255, 192, 227, 245, 255, 160, 203, 230, 255, 178, 213, 235, 255, 215, 241, 253, 255, 218, 245, 255, 255, 164, 204, 228, 254, 71, 123, 163, 90, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 7, 0, 0, 0, 24, 0, 9, 16, 50, 81, 134, 172, 172, 198, 227, 242, 255, 218, 242, 252, 255, 176, 213, 235, 255, 187, 222, 242, 255, 215, 243, 254, 255, 216, 243, 255, 255, 217, 244, 255, 255, 217, 244, 255, 255, 217, 244, 255, 255, 216, 243, 255, 255, 211, 240, 253, 255, 178, 216, 238, 255, 183, 218, 238, 255, 227, 249, 255, 255, 165, 205, 228, 254, 71, 123, 163, 90, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 6, 92, 144, 183, 142, 197, 225, 240, 255, 199, 229, 244, 255, 209, 237, 250, 255, 225, 249, 255, 255, 223, 248, 255, 255, 223, 248, 255, 255, 223, 248, 255, 255, 223, 248, 255, 255, 223, 248, 255, 255, 223, 248, 255, 255, 224, 248, 255, 255, 223, 248, 255, 255, 203, 232, 247, 255, 208, 234, 246, 255, 169, 207, 229, 254, 71, 123, 163, 90, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 93, 145, 184, 133, 175, 209, 230, 255, 196, 227, 241, 255, 197, 229, 242, 255, 196, 228, 241, 255, 195, 228, 241, 255, 195, 228, 241, 255, 195, 228, 241, 255, 195, 228, 241, 255, 195, 228, 241, 255, 195, 228, 241, 255, 195, 228, 241, 255, 196, 228, 241, 255, 197, 228, 242, 255, 198, 227, 241, 255, 154, 194, 221, 248, 74, 123, 161, 87, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 69, 106, 132, 68, 81, 127, 161, 151, 79, 126, 161, 161, 78, 125, 160, 161, 78, 125, 160, 161, 78, 125, 160, 161, 78, 125, 160, 161, 78, 125, 160, 161, 78, 125, 160, 161, 78, 125, 160, 161, 78, 125, 160, 161, 78, 125, 160, 161, 78, 125, 160, 161, 78, 125, 160, 161, 80, 126, 161, 161, 81, 125, 158, 138, 58, 88, 110, 46, 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 12, 0, 0, 0, 25, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 30, 0, 0, 0, 29, 0, 0, 0, 23, 0, 0, 0, 9, 
    },
  }
  return webmail_png
end

