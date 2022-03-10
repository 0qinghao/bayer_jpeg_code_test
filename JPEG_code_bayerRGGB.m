function log = JPEG_code_bayerRGGB(jpeg_Q, tv)

    % jpeg_Q = 95;
    % tv = "3_IT8_rggb_1920x1080_12b";
    rggb_file_name = strcat("./test_img/", tv, ".raw");
    width = 1920;
    height = 1080;

    [R, G1, G2, B, all_c] = bayerRGGB_extract(rggb_file_name, width, height);
    ch_cat_src = [R, G1, G2, B];

    % 12bit preview
    % subplot(2, 2, 1); imshow(bitshift(R, 4)); title("R");
    % subplot(2, 2, 2); imshow(bitshift(G1, 4)); title("G1");
    % subplot(2, 2, 3); imshow(bitshift(G2, 4)); title("G2");
    % subplot(2, 2, 4); imshow(bitshift(B, 4)); title("B");
    subplot(3, 1, 1); imshow(bitshift(ch_cat_src, 4)); title("src");

    R_8b = uint8(round(double(R) / 16));
    G1_8b = uint8(round(double(G1) / 16));
    G2_8b = uint8(round(double(G2) / 16));
    B_8b = uint8(round(double(B) / 16));
    % all_c_8b = uint8(round(double(all_c) / 16));
    ch_cat_8bit = [R_8b, G1_8b, G2_8b, B_8b];

    % 8bit preview
    % subplot(2, 2, 1); imshow(R_8b); title("R-8b");
    % subplot(2, 2, 2); imshow(G1_8b); title("G1-8b");
    % subplot(2, 2, 3); imshow(G2_8b); title("G2-8b");
    % subplot(2, 2, 4); imshow(B_8b); title("B-8b");
    subplot(3, 1, 2); imshow(ch_cat_8bit); title("src 8bit trunc");

    % 截断后 PSNR 影响
    % psnr(all_c, bitshift(uint16(all_c_8b), 4), 2^12 - 1)
    % psnr(ch_cat_src, bitshift(uint16(ch_cat_8bit), 4), 2^12 - 1)

    % jpeg code
    imwrite(R_8b, strcat("./coded_jpeg/", tv, "_R_", int2str(jpeg_Q), ".jpg"), 'quality', jpeg_Q);
    imwrite(G1_8b, strcat("./coded_jpeg/", tv, "_G1_", int2str(jpeg_Q), ".jpg"), 'quality', jpeg_Q);
    imwrite(G2_8b, strcat("./coded_jpeg/", tv, "_G2_", int2str(jpeg_Q), ".jpg"), 'quality', jpeg_Q);
    imwrite(B_8b, strcat("./coded_jpeg/", tv, "_B_", int2str(jpeg_Q), ".jpg"), 'quality', jpeg_Q);

    % jpeg codec PSNR
    R_dec = imread(strcat("./coded_jpeg/", tv, "_R_", int2str(jpeg_Q), ".jpg"));
    G1_dec = imread(strcat("./coded_jpeg/", tv, "_G1_", int2str(jpeg_Q), ".jpg"));
    G2_dec = imread(strcat("./coded_jpeg/", tv, "_G2_", int2str(jpeg_Q), ".jpg"));
    B_dec = imread(strcat("./coded_jpeg/", tv, "_B_", int2str(jpeg_Q), ".jpg"));
    ch_cat_dec = [R_dec, G1_dec, G2_dec, B_dec];
    subplot(3, 1, 3); imshow(ch_cat_dec); title("jpeg codec");
    PSNR = psnr(ch_cat_src, bitshift(uint16(ch_cat_dec), 4), 2^12 - 1);

    % 统计
    R_jpeg_info = dir(strcat("./coded_jpeg/", tv, "_R_", int2str(jpeg_Q), ".jpg"));
    G1_jpeg_info = dir(strcat("./coded_jpeg/", tv, "_G1_", int2str(jpeg_Q), ".jpg"));
    G2_jpeg_info = dir(strcat("./coded_jpeg/", tv, "_G2_", int2str(jpeg_Q), ".jpg"));
    B_jpeg_info = dir(strcat("./coded_jpeg/", tv, "_B_", int2str(jpeg_Q), ".jpg"));
    fsize = R_jpeg_info.bytes + G1_jpeg_info.bytes + G2_jpeg_info.bytes + B_jpeg_info.bytes;
    CR = fsize * 8 / (width * height * 12);
    log = [jpeg_Q, fsize, CR, PSNR];

end
