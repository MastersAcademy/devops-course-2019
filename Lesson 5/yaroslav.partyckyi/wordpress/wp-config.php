<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'root' );

/** MySQL database username */
define( 'DB_USER', 'root' );

/** MySQL database password */
define( 'DB_PASSWORD', 'root' );

/** MySQL hostname */
define( 'DB_HOST', 'db' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '(?eBeMIM~0C7G_-GNdn(7CV`a%Zec3e3AS)-iA/{XKqh$qEd+-E(,t?m<]jn:|u?' );
define( 'SECURE_AUTH_KEY',  'K+ Q`Aur5hXeBF1A8&}$S%z2ck449luzd}euvSwex!Xt3d8*K_LY;le~w9f]Vxr}' );
define( 'LOGGED_IN_KEY',    'd(s~8thutAb@rZ-f-;65F}mFj:CFj2b&WPomoUi/QvGquL,[?a<9MLreODSjr V,' );
define( 'NONCE_KEY',        '-N$-&oPMo^B?7SjVHwHC$#$YciI5dKwO6G78{_pGjFxrV/,l8]w||CzWSGO`B cR' );
define( 'AUTH_SALT',        'u|#JNboN2V|z1&b6i;vfYzLQ=Q#)6 Mqy*nMxgP-]HDb_tJ?LYZ7%:xUoW|F508E' );
define( 'SECURE_AUTH_SALT', '38Pdk)(p*mynz^A76_ 3m8^iQvBGC=?#7dZd.76a[grecL&8Sj*Zt#z%V;9&5YC3' );
define( 'LOGGED_IN_SALT',   'Z@(:Td|n#}P$O$Ht!wvHV%4juih%Kvcc7yrO|><2-c?dh]lpy:u]@4s.Nfsx^^_C' );
define( 'NONCE_SALT',       '5IeVx*)inY<pE:[jsHAB*`NQ*EZz_0_fNs`S>*m]J]b9j4&9iLX7z{yld^p.[HCJ' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
