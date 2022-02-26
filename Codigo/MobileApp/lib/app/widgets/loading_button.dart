import 'package:flutter/material.dart';

class LoadingButton extends ElevatedButton {
  // TODO: test

  const LoadingButton({
    Key? key,
    required void Function()? onPressed,
    required Widget? child,
    bool isLoading = false,
    bool isDisabled = false,
  }) : super(
          key: key,
          onPressed: isDisabled || isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : child,
        );
}
