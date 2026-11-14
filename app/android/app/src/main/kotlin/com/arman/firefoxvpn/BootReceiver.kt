package com.arman.firefoxvpn

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.util.Log

/**
 * Connects when the phone starts, when the user asked for it (the
 * connection settings' "Connect after the phone starts"). Android limits
 * what a background start may do; a boot receiver may start a foreground
 * service. The VPN permission must already be granted (it is, once the
 * user connected once and kept it): without it the boot passes quietly.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED) return
        if (!CoreService.autoConnectOnBoot(context)) return
        // Proxy mode needs no VPN permission; the VPN mode needs it granted
        // already (asking would open a dialog nobody asked for).
        if (CoreService.usesVpn(context) && VpnService.prepare(context) != null) {
            Log.i(TAG, "auto-connect at boot: the VPN has no permission yet")
            return
        }
        try {
            val service = Intent(context, CoreService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(service)
            } else {
                context.startService(service)
            }
            // The service's start connects the core; the core owns the
            // attempts and the retries after that.
            mobile.Mobile.connect()
        } catch (e: Exception) {
            Log.w(TAG, "auto-connect at boot failed", e)
        }
    }

    private companion object {
        const val TAG = "BootReceiver"
    }
}
