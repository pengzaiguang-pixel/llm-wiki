"""
LLM Wiki 图片资源下载器
用于从网页URL下载图片资源并保存到LLM Wiki的assets目录
"""

import os
import requests
from urllib.parse import urlparse
import hashlib
from typing import List, Dict, Optional


class WikiImageDownloader:
    def __init__(self, base_dir: str = "D:/Project/llm-wiki"):
        """
        初始化图片下载器

        Args:
            base_dir: LLM Wiki项目的根目录
        """
        self.base_dir = base_dir
        self.assets_dir = os.path.join(base_dir, "raw", "assets")

        # 确保assets目录存在
        os.makedirs(self.assets_dir, exist_ok=True)

    def get_filename_from_url(self, url: str) -> str:
        """
        从URL中提取文件名

        Args:
            url: 图片URL

        Returns:
            文件名
        """
        parsed_url = urlparse(url)
        filename = os.path.basename(parsed_url.path)

        # 如果URL中没有文件名或扩展名，生成一个
        if not filename or '.' not in filename:
            # 使用URL的哈希值生成文件名
            hash_obj = hashlib.md5(url.encode())
            filename = f"image_{hash_obj.hexdigest()[:8]}.jpg"

        return filename

    def download_single_image(self, url: str, filename: Optional[str] = None,
                            custom_name: Optional[str] = None) -> Dict[str, any]:
        """
        下载单张图片

        Args:
            url: 图片URL
            filename: 指定的文件名
            custom_name: 自定义名称

        Returns:
            下载结果字典
        """
        try:
            response = requests.get(url, stream=True, timeout=30)
            response.raise_for_status()

            # 确定文件名
            if custom_name:
                # 使用自定义名称，保留原始扩展名
                original_ext = os.path.splitext(self.get_filename_from_url(url))[1]
                filename = f"{custom_name}{original_ext}"
            elif not filename:
                filename = self.get_filename_from_url(url)

            filepath = os.path.join(self.assets_dir, filename)

            # 写入文件
            with open(filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)

            return {
                "status": "success",
                "url": url,
                "filepath": filepath,
                "filename": filename
            }
        except Exception as e:
            return {
                "status": "error",
                "url": url,
                "error": str(e)
            }

    def download_multiple_images(self, urls: List[str],
                               custom_names: Optional[List[str]] = None) -> List[Dict[str, any]]:
        """
        批量下载图片

        Args:
            urls: 图片URL列表
            custom_names: 自定义名称列表

        Returns:
            下载结果列表
        """
        results = []

        for i, url in enumerate(urls):
            # 移除URL中的锚点部分
            clean_url = url.split('#')[0]

            custom_name = custom_names[i] if custom_names and i < len(custom_names) else None

            result = self.download_single_image(clean_url, custom_name=custom_name)
            results.append(result)

            if result["status"] == "success":
                print(f"✓ 成功下载: {result['filename']}")
            else:
                print(f"✗ 下载失败: {clean_url} - {result['error']}")

        return results

    def get_asset_reference(self, filename: str) -> str:
        """
        获取资产引用路径

        Args:
            filename: 文件名

        Returns:
            相对路径引用
        """
        return f"../raw/assets/{filename}"


def main():
    """主函数示例"""
    downloader = WikiImageDownloader()

    # 示例图片URL列表
    image_urls = [
        # 这里可以放置需要下载的图片URL
    ]

    # 示例自定义名称
    custom_names = [
        # 这里可以放置对应的自定义名称
    ]

    if image_urls:
        print("开始下载图片...")
        results = downloader.download_multiple_images(image_urls, custom_names)

        success_count = sum(1 for r in results if r["status"] == "success")
        print(f"\n下载完成: {success_count}/{len(results)} 张图片成功")


if __name__ == "__main__":
    main()