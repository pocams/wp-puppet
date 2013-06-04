<?php
/*
Plugin Name: Enable Fancy Permalinks for Nginx
Plugin URI: http://www.example.com
Description: Enables fancy permalinks when running under Nginx
Version: 1.0
Author: Mark Johnston
Author URI: http://www.mhj.ca
License: Public Domain
*/

add_filter( 'got_rewrite', '__return_true' );
