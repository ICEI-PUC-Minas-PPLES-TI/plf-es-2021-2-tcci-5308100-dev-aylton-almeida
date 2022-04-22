import 'package:delivery_manager/app/data/enums/problem_type.dart';
import 'package:delivery_manager/app/widgets/authenticated_app_bar.dart';
import 'package:delivery_manager/app/widgets/keyboard_dismiss_container.dart';
import 'package:delivery_manager/app/widgets/loading_button.dart';
import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:delivery_manager/app/widgets/scrollable_form.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_problems_controller.dart';

class OrderProblemsView extends GetView<OrderProblemsController> {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissContainer(
      child: Scaffold(
        appBar: AuthenticatedAppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: controller.goBack,
          ),
          titleText: 'order_problems'.tr,
        ),
        body: ScrollableForm(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'order_problem_header'.tr,
                  style: Get.textTheme.headline6,
                ),
                const SizedBox(height: 16),
                Text(
                  'order_problem_subheader'.tr,
                  style: Get.textTheme.subtitle2,
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<ProblemType>(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  elevation: 16,
                  onChanged: controller.handleTypeChange,
                  items: controller.problemTypes,
                  decoration: InputDecoration(
                    hintText: 'order_problem_select_hint'.tr,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedTextField(
                  controller: controller.descriptionController,
                  keyboardType: TextInputType.multiline,
                  minLines: 6,
                  maxLines: 6,
                  maxLength: 120,
                  hintText: 'order_problem_input_hint'.tr,
                  borderRadius: 15,
                ),
              ],
            ),
            const Expanded(child: SizedBox(height: 16)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(
                  () => LoadingButton(
                    key: const Key('problem_submit_button'),
                    onPressed: controller.submitProblem,
                    child: Text('send_problem'.tr),
                    isLoading: controller.isLoading,
                    isDisabled: !controller.isValid,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
