import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:collection/collection.dart';

const _equality = DeepCollectionEquality();

List<Operation> diffDocumentsCustom(
  Document oldDocument,
  Document newDocument,
) {
  return diffNodesCustom(oldDocument.root, newDocument.root);
}

List<Operation> diffNodesCustom(Node? oldNode, Node? newNode) {
  final operations = <Operation>[];

  // Handle null cases
  if (oldNode == null && newNode == null) {
    return operations; // No changes needed
  }
  if (oldNode == null && newNode != null) {
    operations.add(InsertOperation(newNode.path, [newNode]));
    return operations;
  }
  if (oldNode != null && newNode == null) {
    operations.add(DeleteOperation(oldNode.path, [oldNode]));
    return operations;
  }

  // Both nodes exist, proceed with diffing
  final safeOldNode = oldNode!;
  final safeNewNode = newNode!;

  // Check if attributes have changed using _equality
  if (!_equality.equals(safeOldNode.attributes, safeNewNode.attributes)) {
    operations.add(
      UpdateOperation(
        safeOldNode.path,
        safeNewNode.attributes,
        safeOldNode.attributes,
      ),
    );
  }

  // Map children by their IDs for efficient comparison
  final oldChildrenById = {
    for (final child in safeOldNode.children.where((c) => c.id != null))
      child.id: child,
  };
  final newChildrenById = {
    for (final child in safeNewNode.children.where((c) => c.id != null))
      child.id: child,
  };

  // Identify common, deleted, and inserted nodes
  final commonIds =
      oldChildrenById.keys.toSet().intersection(newChildrenById.keys.toSet());
  final deletedIds =
      oldChildrenById.keys.toSet().difference(newChildrenById.keys.toSet());
  final insertedIds =
      newChildrenById.keys.toSet().difference(oldChildrenById.keys.toSet());

  // Handle deletions
  for (final id in deletedIds) {
    final oldChild = oldChildrenById[id]!;
    operations.add(DeleteOperation(oldChild.path, [oldChild]));
  }

  // Handle insertions
  for (final id in insertedIds) {
    final newChild = newChildrenById[id]!;
    operations.add(InsertOperation(newChild.path, [newChild]));
  }

  // Handle moves and updates for nodes present in both documents
  for (final id in commonIds) {
    final oldChild = oldChildrenById[id]!;
    final newChild = newChildrenById[id]!;

    // Compare paths to detect moves
    if (!_arePathsEqual(oldChild.path, newChild.path)) {
      // Simulate a move with delete and insert
      operations.add(DeleteOperation(oldChild.path, [oldChild]));
      operations.add(InsertOperation(newChild.path, [newChild]));
    } else {
      // Recursively diff unchanged-position nodes
      operations.addAll(diffNodesCustom(oldChild, newChild));
    }
  }

  return operations;
}

// Helper function to compare paths
bool _arePathsEqual(List<int> oldPath, List<int> newPath) {
  if (oldPath.length != newPath.length) return false;
  for (var i = 0; i < oldPath.length; i++) {
    if (oldPath[i] != newPath[i]) return false;
  }
  return true;
}
