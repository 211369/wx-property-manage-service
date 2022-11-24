<div class="top_nav">
    <div class="nav_menu">
        <nav>
            <div class="nav toggle">
                <a id="menu_toggle"><i class="fa fa-bars"></i></a>
            </div>
            <ul class="nav navbar-nav navbar-right">
                <li class="">
                    <a href="javascript:;" class="user-profile dropdown-toggle">
                        <img src="/assets/images/user.png" alt=""><#if user?exists>${user.nickname?if_exists}<#else></#if><#if user?exists>${user.username?if_exists}<#else>管理员</#if>
                        <span onclick="logoutSys()"><i class="fa fa-power-off"></i>退出</span>
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</div>
<script>
function logoutSys() {
    window.location.href="/passport/logout"
}
</script>