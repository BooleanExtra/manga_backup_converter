import 'package:flutter/material.dart';
import 'package:mangabackupconverter/src/features/settings/data/dto/human_name_enum.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

Future<OptionT?> showOptionsMenu<OptionT extends HumanReadableEnum>(
  BuildContext context, {
  required OptionT current,
  required List<OptionT> options,
  required String title,
}) async {
  return await WoltModalSheet.show<OptionT>(
    context: context,
    useRootNavigator: true,
    pageListBuilder: (BuildContext context) {
      final ThemeData theme = Theme.of(context);
      return <SliverWoltModalSheetPage>[
        SliverWoltModalSheetPage(
          topBarTitle: Center(
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
          isTopBarLayerAlwaysVisible: true,
          leadingNavBarWidget: const Padding(
            padding: EdgeInsetsDirectional.all(16.0),
            child: CloseButton(),
          ),
          mainContentSliversBuilder: (BuildContext context) => <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                for (final OptionT eachOption in options)
                  ListTile(
                    title: Text(
                      eachOption.humanName,
                      style: current == eachOption
                          ? const TextStyle(fontWeight: FontWeight.bold)
                          : null,
                    ),
                    onTap: () {
                      Navigator.of(context).pop(eachOption);
                    },
                    trailing: current == eachOption
                        ? const Icon(Icons.check)
                        : null,
                  ),
              ]),
            ),
          ],
        ),
      ];
    },
  );
}
