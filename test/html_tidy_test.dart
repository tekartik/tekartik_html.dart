library document_test;

import 'package:tekartik_html/html.dart';
import 'package:tekartik_html/html_html5lib.dart';
import 'package:tekartik_html/util/html_tidy.dart';
import 'package:dev_test/test.dart';

main() {
  HtmlProvider html = htmlProviderHtml5Lib;
  test_main(html);
}

test_main(HtmlProvider html) {
  group('tidy', () {
    group('document', () {
      test('html_attributes', () {
        Document doc = html.createDocument(title: 'test');
        doc.html.attributes['⚡'] = '';
        expect(htmlTidyDocument(doc), [
          '<!DOCTYPE html>',
          '<html ⚡>',
          '<head>',
          '\t<meta charset="utf-8">',
          '\t<title>test</title>',
          '</head>',
          '<body></body>',
          '</html>'
        ]);
      });
    });

    group('indent', () {
      test('sub_div_element', () {
        Element element =
            html.createElementHtml("<div><div><div></div></div></div>");
        expect(htmlTidyElement(element, new HtmlTidyOption()..indent = ' '),
            ['<div>', ' <div>', '  <div></div>', ' </div>', '</div>']);
      });
    });
    group('element', () {
      test('style_element', () {
        Element element =
            html.createElementHtml("<style>body {\n\tmargin: 0;\n}</style>");
        //print(element.outerHtml);
        expect(htmlTidyElement(element),
            ['<style>', '\tbody {', '\t\tmargin: 0;', '\t}', '</style>']);
        html.createElementHtml("<style>body {\r\tmargin: 0;\r}</style>");
        expect(htmlTidyElement(element),
            ['<style>', '\tbody {', '\t\tmargin: 0;', '\t}', '</style>']);
      });
      test('style_element_single_line', () {
        // from amp
        Element element =
            html.createElementHtml("<style>body {opacity: 0}</style>");
        //print(element.outerHtml);
        expect(htmlTidyElement(element), ['<style>body {opacity: 0}</style>']);
      });
      test('title_element', () {
        Element element = html.createElementHtml("<title>some  text</title>");
        expect(htmlTidyElement(element), ['<title>some  text</title>']);
      });

      test('void_input_element', () {
        Element element = html.createElementTag('input');
        expect(element.outerHtml, "<input>");
        expect(htmlTidyElement(element), ['<input>']);
      });

      test('span_element', () {
        Element element = html.createElementHtml("<span>test</span>");
        expect(htmlTidyElement(element), ['<span>test</span>']);
      });

      test('paragraph_long', () {
        Element element = html.createElementHtml(
            '<p>0123456789 012345678 012345678910 0123456 789 12345\n</p>');
        //expect(htmlTidyElement(element), ['<input>']);
        //print(element.outerHtml);
        expect(
            htmlTidyElement(element, new HtmlTidyOption()..contentLength = 10),
            [
          '<p>',
          '\t0123456789',
          '\t012345678',
          '\t012345678910',
          '\t0123456',
          '\t789 12345',
          '</p>'
        ]);
      });

      test('paragraph', () {
        Element element = html.createElementTag('p');
        expect(htmlTidyElement(element), ['<p></p>']);
      });

      test('div_element', () {
        Element element = html.createElementHtml("<div>some  text\r</div>");
        expect(htmlTidyElement(element), ['<div>', '\tsome text', '</div>']);
      });

      test('sub_div_element', () {
        Element element = html.createElementHtml("<div><div></div></div>");
        expect(htmlTidyElement(element), ['<div>', '\t<div></div>', '</div>']);
      });

      test('sub_sub_div_element', () {
        Element element =
            html.createElementHtml("<div><div><div></div></div></div>");
        expect(htmlTidyElement(element),
            ['<div>', '\t<div>', '\t\t<div></div>', '\t</div>', '</div>']);
      });

      test('text_node', () {
        Element element = html.createElementHtml("<div>some text</div>");
        expect(htmlTidyElement(element), ['<div>some text</div>']);
        element = html.createElementHtml("<div>some\ntext</div>");
        expect(htmlTidyElement(element), ['<div>', '\tsome text', '</div>']);
      });

      test('anchor_with_inner_element', () {
        Element element = html.createElementHtml('<a><img/></a>');
        //print(element.outerHtml);
        expect(htmlTidyElement(element), ['<a>', '\t<img>', '</a>']);
      });
    });
  });
}