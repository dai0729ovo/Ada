<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Astra Landing Page</title>
    <style>
        /* 基础重置与字体 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* 页面主体背景：紫蓝色渐变 */
        body {
            background: linear-gradient(135deg, #3a0ca3, #7209b7, #b5179e);
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* --- 顶部导航栏 --- */
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 2rem 8%;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.5rem;
            font-weight: bold;
            letter-spacing: 1px;
        }

        /* Logo 图片占位符样式 */
        .logo img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.2); /* 没有图片时的背景色 */
            object-fit: contain;
        }

        nav {
            display: flex;
            gap: 25px;
        }

        nav a {
            color: #ffffff;
            text-decoration: none;
            font-size: 0.95rem;
            opacity: 0.9;
            transition: opacity 0.3s;
        }

        nav a:hover {
            opacity: 1;
        }

        /* --- 主视觉区域 (Hero Section) --- */
        .hero {
            display: flex;
            flex: 1;
            align-items: center;
            justify-content: space-between;
            padding: 0 8%;
            gap: 4rem;
        }

        /* 左侧文字区 */
        .text-content {
            flex: 1;
            max-width: 500px;
        }

        .text-content h1 {
            font-size: 3.5rem;
            line-height: 1.2;
            margin-bottom: 1.5rem;
        }

        .text-content p {
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 2.5rem;
            color: rgba(255, 255, 255, 0.8);
        }

        .btn {
