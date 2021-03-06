<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"  isELIgnored="false" %>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>用户管理</title>
    <link rel="stylesheet" href="/static/layui-v2.5.6/layui/css/layui.css">
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <div class="layui-logo">心秘籍</div>
        <ul class="layui-nav layui-layout-left">
            <li class="layui-nav-item">
                <h1>用户管理</h1>
            </li>
        </ul>
        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item">
                <a href="javascript:;">
                    <span>${ user.is_admin ? "管理员" : "用户" }</span>
                    <span>${ user.name }</span>
                </a>
                <dl class="layui-nav-child">
                    <dd><a href="/page/user/my-questionnaire-list?obj_uid=${ user.uid }">我的心理报告</a></dd>
                    <dd><a href="/page/logout">退出登录</a></dd>
                </dl>
            </li>
        </ul>
    </div>
    <span style="opacity: 0.3; position: fixed;">
    <img style="width:100%; " src="/static/pic/鹿乃晴天女子.png">
    </span>

    <div class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <ul class="layui-nav layui-nav-tree">
                <li class="layui-nav-item">
                    <a href="/page/home">主页</a>
                </li>
                <li class="layui-nav-item layui-nav-itemed">
                    <a href="javascript:;">心理测评</a>
                    <dl class="layui-nav-child">
                        <dd><a href="/page/questionnaire-list">心理测评大全</a></dd>
                        <c:if test="${ user.is_admin }">
                            <dd><a href="/page/new-questionnaire">新建心理测评</a></dd>
                        </c:if>
                        <dd><a href="/page/user/my-questionnaire-list?obj_uid=${ user.uid }">查看我的心理报告</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;">心理科普</a>
                    <dl class="layui-nav-child">
                        <dd><a href="/page/article-list">专栏大全</a></dd>
                        <c:if test="${ user.is_admin }">
                            <dd><a href="/page/article-new">添加专栏</a></dd>
                        </c:if>
                    </dl>
                </li>
                <c:if test="${ user.is_admin }">
                    <li class="layui-nav-item">
                        <a href="javascript:;">系统管理</a>
                        <dl class="layui-nav-child">
                            <dd><a href="/page/users">用户管理</a></dd>
                        </dl>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>

    <div class="layui-body">
        <div class="layui-container" style="margin-top: 15px">

            <fieldset class="layui-elem-field layui-field-title">
                <legend>用户管理<em>管理员模式</em></legend>
            </fieldset>

            <table lay-filter="tbl-users">
                <thead>
                <tr>
                    <th lay-data="{field:'uid'}">用户ID</th>
                    <th lay-data="{field:'name'}">用户名</th>
                    <th lay-data="{field:'priority'}">权限</th>
                    <th lay-data="{field:'view'}">查看</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${ users }">
                    <tr>
                        <td>${ u.uid }</td>
                        <td>${ u.name }</td>
                        <td>
                                ${ u.is_admin ? "管理员" : "用户" }
                            <button class="layui-btn layui-btn-primary layui-btn-xs btn-switch-prty"
                                    data-uid="${ u.uid }" data-prty="${ u.is_admin }">
                                切换
                            </button>
                        </td>
                        <td>
                            <a class="layui-btn layui-btn-primary layui-btn-xs btn-view-qns" href="/page/user/my-questionnaire-list?obj_uid=${ u.uid }">
                                查看测评
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                </tbody>
            </table>
            <div id="switch-pages"></div>

        </div>
    </div>

    <div class="layui-footer">
        第14组 心秘籍
    </div>
</div>
<script src="/static/jquery-3.4.1/dist/jquery-3.4.1.min.js" charset="utf-8"></script>
<script src="/static/layui-v2.5.6/layui/layui.js" charset="utf-8"></script>
<script>
    layui.use(['element', 'form', 'table', 'laypage'], function () {
        layui.form.verify({
            not_empty: function (value) {
                if(value.length == 0) {
                    return "此处不能为空";
                }
            }
        });
        layui.table.init('tbl-users');
        $(".btn-switch-prty").click(function () {
            let uid = $(this).data('uid');
            let prty = $(this).data('prty');
            $.post('/api/user/priority', {
                uid: uid,
                is_admin: !prty
            }, function () {
                layer.msg('转换成功', function () {
                    window.location.reload();
                });
            });
        });

        layui.laypage.render({
            elem: 'switch-pages',
            curr: ${ pageInfo.pageNum },
            count: ${ pageInfo.total },
            limit: ${ pageInfo.pageSize },
            jump: function (obj) {
                if(obj.curr != ${ pageInfo.pageNum }) {
                    window.location.href = "?pageNum=" + obj.curr + "&pageSize=" + obj.limit;
                }
            }
        });
    });
</script>
</body>
</html>
