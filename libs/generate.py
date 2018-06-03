# 用来生成带数字的二维码
from MyQR import myqr
import os
from PIL import Image, ImageFont, ImageDraw
import base64
import json


# 根据数字生成带数字的二维码
def generate_qrcode_with_num(step_id, next_item_id, product_id, item_id):
    file_name = generate_num_pic(item_id)
    file_gen = "qrcodes\\qrcode" + str(item_id) + r".jpg"
    if os.path.exists(file_gen):
        return file_gen
    myqr.run(base64.b64encode(json.dumps({
        "step_id": step_id,
        "next_items": next_item_id,
        "product_id": product_id,
        "item_id": item_id
    }).encode("utf-8")).decode(), version=4, level='M',
             picture=file_name, save_name=file_gen)
    return file_gen


# 生成数字图片
def generate_num_pic(num):
    file_name = "nums\\" + str(num) + r".jpg"
    if os.path.exists(file_name):
        return file_name
    width, height = 50, 50
    image = Image.new("RGB", (width, height), (255, 255, 255))
    font = ImageFont.truetype("wqy-zenhei.ttc", 30)
    draw = ImageDraw.Draw(image)
    font_width, font_height = font.getsize(str(num))
    draw.text(((width - font_width) / 1.8, 5), str(num), font=font, fill=(0, 0, 0))
    image.save(file_name)
    return file_name


if __name__ == "__main__":
    generate_qrcode_with_num(0, 1, 1, 0)
    generate_qrcode_with_num(1, 2, 1, 1)
    generate_qrcode_with_num(2, 3, 1, 2)
    generate_qrcode_with_num(3, 5, 1, 3)
    generate_qrcode_with_num(4, 6, 1, 4)
